/// TODO: Move to a separate repository
/// TODO: Use checksummed addresses
module utils.ethereum;

struct ETHAddress {
    import std.conv;

    ubyte[21] value;

    @property string hex() {
        return "0x" ~ hexWithout0x;
    }

    @property void hex(string str)
        in(str[0..2] == "0x")
    {
        hexWithout0x = str[2..$];
    }

    @property string hexWithout0x() {
        import std.digest;
        return value.toHexString!(Order.decreasing, LetterCase.lower);
    }

    @property void hexWithout0x(string str)
        in(str.length == 42)
    {
        import std.range, std.algorithm;
        value = str.chunks(2).map!(xx => xx.to!ubyte(16)).array;
    }
}