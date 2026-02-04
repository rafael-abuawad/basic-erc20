import getpass

import boa
from eth_account import Account


def load_keystore_account():
    """Load an account from a keystore file securely."""
    with open("account.keystore.json", "r") as acc:
        password = getpass.getpass("\tEnter your keystore password: ")
        encrypted_account = acc.read()
        account_pk = Account.decrypt(encrypted_account, password)
        return Account.from_key(account_pk)


def main():
    rpc_url = "https://arb1.arbitrum.io/rpc"

    with boa.set_network_env(rpc_url):
        account = load_keystore_account()
        boa.env.add_account(account)

        print(f"Deploying contract with account: {account.address}...")

        erc20_contract = boa.load(
            "contracts/ERC20.vy",
            "Mi Token",  # _name
            "MTB",  # _symbol
        )

        print(f"Success! Contract deployed at: {erc20_contract.address}")
        return erc20_contract


if __name__ == "__main__":
    main()
