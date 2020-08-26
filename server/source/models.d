import hunt.entity;
import std.datetime.date;
import utils.ethereum;

@Table("person")
class Person : Model
{
    mixin MakeModel;

    @PrimaryKey
    @AutoIncrement
    uint id;

    uint esiaID;
    bool alive = true;
    DateTime birthDate;

    ETHAddress ethAddress; // can be changed by the user
}