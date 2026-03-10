// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/before/BeforeERC20.sol";
import "../src/after/AfterERC20.sol";

contract ERC20GasComparisonTest is Test {
    BeforeERC20 beforeToken;
    AfterERC20 afterToken;

    address alice = address(0xA11CE);
    address bob = address(0xB0B);
    address carol = address(0xCA01);

    uint256 constant INITIAL_SUPPLY = 1_000_000 ether;

    function setUp() public {
        beforeToken = new BeforeERC20(INITIAL_SUPPLY);
        afterToken = new AfterERC20(INITIAL_SUPPLY);
    }

    function _assertSameState(address user1, address user2) internal view {
        assertEq(beforeToken.totalSupply(), afterToken.totalSupply());
        assertEq(beforeToken.duplicateTotalSupply(), afterToken.duplicateTotalSupply());
        assertEq(beforeToken.balanceOf(user1), afterToken.balanceOf(user1));
        assertEq(beforeToken.balanceOf(user2), afterToken.balanceOf(user2));
    }

    function testInitialSupplyAssignedToDeployer() public view {
        assertEq(beforeToken.balanceOf(address(this)), INITIAL_SUPPLY);
        assertEq(afterToken.balanceOf(address(this)), INITIAL_SUPPLY);
    }

    function testTransferSameBehavior() public {
        beforeToken.transfer(alice, 100 ether);
        afterToken.transfer(alice, 100 ether);

        _assertSameState(address(this), alice);
    }

    function testTransferTaxBurnApplied() public {
        beforeToken.transfer(alice, 100 ether);
        afterToken.transfer(alice, 100 ether);

        uint256 expectedReceived = 95 ether;
        uint256 expectedSupply = INITIAL_SUPPLY - 5 ether;

        assertEq(beforeToken.balanceOf(alice), expectedReceived);
        assertEq(afterToken.balanceOf(alice), expectedReceived);
        assertEq(beforeToken.totalSupply(), expectedSupply);
        assertEq(afterToken.totalSupply(), expectedSupply);
    }

    function testApproveSameBehavior() public {
        beforeToken.approve(alice, 250 ether);
        afterToken.approve(alice, 250 ether);

        assertEq(beforeToken.allowance(address(this), alice), 250 ether);
        assertEq(afterToken.allowance(address(this), alice), 250 ether);
    }

    function testTransferFromSameBehavior() public {
        beforeToken.approve(alice, 200 ether);
        afterToken.approve(alice, 200 ether);

        vm.prank(alice);
        beforeToken.transferFrom(address(this), bob, 100 ether);

        vm.prank(alice);
        afterToken.transferFrom(address(this), bob, 100 ether);

        _assertSameState(address(this), bob);
    }

    function testTransferFromReducesAllowance() public {
        beforeToken.approve(alice, 200 ether);
        afterToken.approve(alice, 200 ether);

        vm.prank(alice);
        beforeToken.transferFrom(address(this), bob, 100 ether);

        vm.prank(alice);
        afterToken.transferFrom(address(this), bob, 100 ether);

        assertEq(beforeToken.allowance(address(this), alice), 100 ether);
        assertEq(afterToken.allowance(address(this), alice), 100 ether);
    }

    function testPauseBlocksTransfer() public {
        beforeToken.setPaused(true);
        afterToken.setPaused(true);

        vm.expectRevert();
        beforeToken.transfer(alice, 1 ether);

        vm.expectRevert();
        afterToken.transfer(alice, 1 ether);
    }

    function testPauseBlocksApprove() public {
        beforeToken.setPaused(true);
        afterToken.setPaused(true);

        vm.expectRevert();
        beforeToken.approve(alice, 1 ether);

        vm.expectRevert();
        afterToken.approve(alice, 1 ether);
    }

    function testOnlyOwnerCanPause() public {
        vm.prank(alice);
        vm.expectRevert();
        beforeToken.setPaused(true);

        vm.prank(alice);
        vm.expectRevert();
        afterToken.setPaused(true);
    }

    function testTransferZeroReverts() public {
        vm.expectRevert();
        beforeToken.transfer(alice, 0);

        vm.expectRevert();
        afterToken.transfer(alice, 0);
    }

    function testTransferToZeroReverts() public {
        vm.expectRevert();
        beforeToken.transfer(address(0), 1 ether);

        vm.expectRevert();
        afterToken.transfer(address(0), 1 ether);
    }

    function testInsufficientBalanceReverts() public {
        vm.prank(alice);
        vm.expectRevert();
        beforeToken.transfer(bob, 1 ether);

        vm.prank(alice);
        vm.expectRevert();
        afterToken.transfer(bob, 1 ether);
    }

    function testBatchTransferSameBehavior() public {
        address[] memory recipients = new address[](2);
        uint256[] memory amounts = new uint256[](2);

        recipients[0] = alice;
        recipients[1] = bob;
        amounts[0] = 100 ether;
        amounts[1] = 200 ether;

        beforeToken.transferMany(recipients, amounts);
        afterToken.transferMany(recipients, amounts);

        _assertSameState(alice, bob);
    }

    function testBatchLengthMismatchReverts() public {
        address[] memory recipients = new address[](2);
        uint256[] memory amounts = new uint256[](1);

        recipients[0] = alice;
        recipients[1] = bob;
        amounts[0] = 100 ether;

        vm.expectRevert();
        beforeToken.transferMany(recipients, amounts);

        vm.expectRevert();
        afterToken.transferMany(recipients, amounts);
    }

    function testMultipleTransfersRemainEquivalent() public {
        beforeToken.transfer(alice, 100 ether);
        afterToken.transfer(alice, 100 ether);

        vm.prank(alice);
        beforeToken.transfer(bob, 50 ether);

        vm.prank(alice);
        afterToken.transfer(bob, 50 ether);

        _assertSameState(alice, bob);
    }
}