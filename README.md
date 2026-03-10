
## Gas Results

Measured with:

```bash
forge test --gas-report
```

| Function | Before Gas | After Gas | Gas Saved | % Savings |
|----------|-----------:|----------:|----------:|----------:|
| Deploy | 938,245 | 634,158 | 304,087 | 32.41% |
| approve | 43,502 | 42,087 | 1,415 | 3.25% |
| transfer | 48,466 | 43,216 | 5,250 | 10.83% |
| transferFrom | 79,708 | 69,537 | 10,171 | 12.76% |
| transferMany | 65,181 | 58,632 | 6,549 | 10.05% |

### Key Takeaways

- Deployment cost reduced by **32.41%**
- `transferFrom` reduced by **12.76%**
- `transfer` reduced by **10.83%**
- `transferMany` reduced by **10.05%**
- Same functionality preserved across both contracts with **15 passing Foundry tests**

## Live Deployments on Sepolia

### BeforeERC20
- Contract Address: `0xD8c291DD75b81C6a345A29ADc02F726fce19f597`
- Transaction Hash: `0xb21079c165e97a2def760b24cdc279a360b6aaa2c7cb685e8ee024ff80a17725`
- Block: `10420244`
- Deployment Gas Used: `938245`

### AfterERC20
- Contract Address: `0x8d617D0C184d60d3328caa54955A00D23b55243d`
- Transaction Hash: `0xbd02efcd9a4ac40f5147402319d30ebc5fef8df3494d9b749763152c8f205bfc`
- Block: `10420259`
- Deployment Gas Used: `634158`

### Deployment Summary

The optimized ERC20 reduced deployment gas from **938245** to **634158**, saving **304087 gas** or **32.41%** while preserving the same functionality.

## Contract Verification

Both contracts are verified on Sepolia Etherscan.

### BeforeERC20
- Address: `0xD8c291DD75b81C6a345A29ADc02F726fce19f597`

### AfterERC20
- Address: `0x8d617D0C184d60d3328caa54955A00D23b55243d`

## Live Deployments on Sepolia

### BeforeERC20
- Contract Address: `0xD8c291DD75b81C6a345A29ADc02F726fce19f597`
- Transaction Hash: `0xb21079c165e97a2def760b24cdc279a360b6aaa2c7cb685e8ee024ff80a17725`
- Block: `10420244`
- Deployment Gas Used: `938245`

### AfterERC20
- Contract Address: `0x8d617D0C184d60d3328caa54955A00D23b55243d`
- Transaction Hash: `0xbd02efcd9a4ac40f5147402319d30ebc5fef8df3494d9b749763152c8f205bfc`
- Block: `10420259`
- Deployment Gas Used: `634158`

### Deployment Summary
The optimized ERC20 reduced deployment gas from **938245** to **634158**, saving **304087 gas** or **32.41%** while preserving the same functionality.