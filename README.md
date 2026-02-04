# Basic ERC20

A minimal ERC20 token implementation in [Vyper](https://vyperlang.org/), deployable to Arbitrum via [Titanoboa](https://github.com/vyperlang/titanoboa).

## Features

- **Standard ERC20**: `transfer`, `approve`, `transferFrom`, with `Transfer` and `Approval` events
- **View functions**: `name()`, `symbol()`, `decimals()` (fixed at 18)
- **Mint**: Owner-only `mint(_to, _value)` for issuing new tokens
- **Immutables**: Token name, symbol, decimals, and owner set at deployment

## Requirements

- Python 3.11+
- [uv](https://docs.astral.sh/uv/) (recommended) or pip

## Setup

```bash
# Clone and enter the project
cd basic-erc20

# Install dependencies with uv
uv sync
```

## Project structure

```
basic-erc20/
├── contracts/
│   └── ERC20.vy      # Vyper ERC20 contract
├── scripts/
│   └── deploy.py     # Deployment script (Arbitrum)
├── pyproject.toml
└── README.md
```

## Deployment

The deploy script uses Titanoboa to deploy to **Arbitrum One** and expects an account from a keystore file.

1. **Create a keystore** (if needed) and save it as `account.keystore.json` in the project root.

2. **Run the deploy script** (you will be prompted for the keystore password):

   ```bash
   uv run python scripts/deploy.py
   ```

3. The script deploys the contract with:
   - **Name**: `Mi Token`
   - **Symbol**: `MTB`
   - **RPC**: `https://arb1.arbitrum.io/rpc`

To change name, symbol, or RPC, edit the values in `scripts/deploy.py`.

## Contract (ERC20.vy)

| Item        | Value                          |
|------------|---------------------------------|
| Vyper      | 0.4.3                          |
| Decimals   | 18                             |
| Constructor| `_name: String[10], _symbol: String[5]` |

External functions: `transfer`, `approve`, `transferFrom`, `mint` (owner only), `name`, `symbol`, `decimals`.

## License

See repository license.
