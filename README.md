
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