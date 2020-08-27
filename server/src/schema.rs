table! {
    person (id) {
        id -> Int4,
        esiaid -> Int8,
        alive -> Nullable<Bool>,
        birthdate -> Date,
        ethaddress -> Nullable<Bpchar>,
    }
}
