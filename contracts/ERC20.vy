# pragma version ==0.4.3


event Transfer:
    _from: indexed(address)
    _to: indexed(address)
    _value: uint256


event Approval:
    _owner: indexed(address)
    _spender: indexed(address)
    _value: uint256


# Inmutables
NAME: immutable(String[10])
SYMBOL: immutable(String[5])
DECIMALS: immutable(uint8)
OWNER: immutable(address)

# Variables de almacenamiento
balanceOf: public(HashMap[address, uint256])
allowance: public(HashMap[address, HashMap[address, uint256]])
totalSupply: public(uint256)


@deploy
def __init__(_name: String[10], _symbol: String[5]):
    NAME = _name
    SYMBOL = _symbol
    DECIMALS = 18
    OWNER = msg.sender


@external
def transfer(_to: address, _value: uint256) -> bool:
    """
    @dev Transfiere tokens a una dirección especificada.
    @param _to La dirección a la que se transfiere.
    @param _value La cantidad a transferir.
    """
    self.balanceOf[msg.sender] -= _value
    self.balanceOf[_to] += _value
    log Transfer(_from=msg.sender, _to=_to, _value=_value)
    return True


@external
def approve(_spender: address, _value: uint256) -> bool:
    """
    @dev Autoriza a `_spender` a transferir hasta `_value` tokens.
    """
    self.allowance[msg.sender][_spender] = _value
    log Approval(_owner=msg.sender, _spender=_spender, _value=_value)
    return True


@external
def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
    """
    @dev Mueve tokens de `_from` a `_to` usando el mecanismo de allowance.
    """
    self.allowance[_from][msg.sender] -= _value
    self.balanceOf[_from] -= _value
    self.balanceOf[_to] += _value
    log Transfer(_from=_from, _to=_to, _value=_value)
    return True


@external
def mint(_to: address, _value: uint256) -> bool:
    """
    @dev Acuña `_value` cantidad de monedas a `_to`
    """
    assert msg.sender == OWNER  # dev: only owner can mint
    self._mint(_to, _value)
    return True


@external
@view
def name() -> String[10]:
    return NAME


@external
@view
def symbol() -> String[5]:
    return SYMBOL


@external
@view
def decimals() -> uint8:
    return DECIMALS


@internal
def _mint(_to: address, _value: uint256):
    self.balanceOf[_to] += _value
    self.totalSupply += _value
    log Transfer(_from=empty(address), _to=_to, _value=_value)
