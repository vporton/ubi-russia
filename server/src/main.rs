#[macro_use] extern crate diesel;

mod models;
mod schema;

use diesel::prelude::*;
use server::establish_connection;
use crate::schema::persons::columns::{esiaid, birthdate, ethaddress};
use crate::models::to_repr;

fn main() {
    let conn = establish_connection();

    use schema::persons;
    diesel::insert_into(persons::table)
        .values((esiaid.eq(123), birthdate.eq(chrono::NaiveDateTime::from_timestamp(201523423, 0)), ethaddress.eq(to_repr(ethereum_types::Address::from(0)))))
        .execute(&conn).expect("Can't insert.");
}
