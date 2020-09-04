extern crate diesel;

fn run(&connection: Connection) {
    use schema::ethereum_transactions::dsl::*;

    let (tx, rx) = channel();

    let handle = thread::spawn(/*move*/ || {
        let next_transactions = ethereum_transactions.order(id).groupBy(userAddress)
            .limit(1)
            .load::<Transaction>(&connection)
            .expect("Error loading posts");
        if next_transactions.len() != 0 {
            let next_transaction = next_transactions[0];

        } else {
            tx.send(()).expect("Could not send signal on channel.");
        }
    });
}