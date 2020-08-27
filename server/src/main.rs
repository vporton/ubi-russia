#![feature(proc_macro_hygiene)]
#![feature(decl_macro)]
#[macro_use] extern crate diesel;
#[macro_use] extern crate rocket;
extern crate rocket_contrib;

mod models;
mod schema;

// use server::establish_connection;
use rocket_contrib::templates::Template;
use std::collections::HashMap;

#[get("/")]
fn index() -> Template {
    let mut context = HashMap::new();
    context.insert("title", "Домашняя страница");
    Template::render("index", &context)
}

fn main() {
    // let conn = establish_connection();

    // use schema::persons;
    // diesel::insert_into(persons::table)
    //     .values((esiaid.eq(123), birthdate.eq(chrono::NaiveDateTime::from_timestamp(201523423, 0)), ethaddress.eq(to_repr(ethereum_types::Address::from(0)))))
    //     .execute(&conn).expect("Can't insert.");

    rocket::ignite()
        .attach(Template::fairing())
        .mount("/", routes![index])
        .launch();
}
