import getpass

import boa
from eth_account import Account


def load_keystore_account():
    """Carga una cuenta desde un archivo keystore de forma segura."""
    with open("account.keystore.json", "r") as acc:
        password = getpass.getpass("\t Ingrese su contraseña del Keystore: ")
        encrypted_account = acc.read()
        account_pk = Account.decrypt(encrypted_account, password)
        return Account.from_key(account_pk)


def main():
    rpc_url = "https://arb1.arbitrum.io/rpc"

    with boa.set_network_env(rpc_url):
        account = load_keystore_account()
        boa.env.add_account(account)

        print(f"Desplegando contrato con la cuenta: {account.address}...")

        erc20_contract = boa.load(
            "contracts/ERC20.vy",
            "Mi Token",  # _name
            "MTB",  # _symbol
        )

        print(f"¡Éxito! Contrato desplegado en: {erc20_contract.address}")
        return erc20_contract


if __name__ == "__main__":
    main()
