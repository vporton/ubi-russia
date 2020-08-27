extern crate ethereum_types;

use std::str::FromStr;

#[allow(dead_code)]
pub fn to_repr(addr: ethereum_types::Address) -> String {
    format!("{:x}", addr)
}

#[allow(dead_code)]
pub fn from_repr(s: &str) -> ethereum_types::Address {
    FromStr::from_str(s).unwrap() // FIXME: check error
}

#[derive(Queryable)]
pub struct Person {
    pub id: u64,
    pub esia_id: u64,
    pub alive: bool,
    pub birth_date: chrono::NaiveDateTime,
    pub eth_address: ethereum_types::Address,
}

impl Person {
    #[allow(dead_code)]
    fn eth_address_repr(self) {
        to_repr(self.eth_address);
    }
    #[allow(dead_code)]
    fn set_eth_address_repr(mut self, s: String) {
        self.eth_address = from_repr(&s);
    }
}