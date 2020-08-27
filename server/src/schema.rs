table! {
    persons (id) {
        id -> Int8,
        esiaid -> Int8,
        alive -> Bool,
        birthdate -> Timestamp,
        ethaddress -> Nullable<Bpchar>,
    }
}
