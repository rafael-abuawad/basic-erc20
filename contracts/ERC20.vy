# pragma version ==0.4.3


event Transfer:
    _from: indexed(address)
    _to: indexed(address)
    _value: uint256


event Approval:
    _owner: indexed(address)
    _spender: indexed(address)
    _value: uint256


# Immutables
NAME: immutable(String[10])
SYMBOL: immutable(String[5])
DECIMALS: immutable(uint8)
OWNER: immutable(address)

# Storage variables
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
    @dev Transfers tokens to a specified address.
    @param _to The address to transfer to.
    @param _value The amount to transfer.
    """
    self.balanceOf[msg.sender] -= _value
    self.balanceOf[_to] += _value
    log Transfer(_from=msg.sender, _to=_to, _value=_value)
    return True


@external
def approve(_spender: address, _value: uint256) -> bool:
    """
    @dev Allows `_spender` to transfer up to `_value` tokens on behalf of the caller.
    """
    self.allowance[msg.sender][_spender] = _value
    log Approval(_owner=msg.sender, _spender=_spender, _value=_value)
    return True


@external
def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
    """
    @dev Moves tokens from `_from` to `_to` using the allowance mechanism.
    """
    self.allowance[_from][msg.sender] -= _value
    self.balanceOf[_from] -= _value
    self.balanceOf[_to] += _value
    log Transfer(_from=_from, _to=_to, _value=_value)
    return True


@external
def mint(_to: address, _value: uint256) -> bool:
    """
    @dev Mints `_value` tokens to `_to`.
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
