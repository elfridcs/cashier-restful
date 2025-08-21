#[path = "./routes/api.rs"]
mod route_api;

#[tokio::main]
async fn main() {
    let route = route_api::apis();
    let host = format!("{}:{}", String::from("127.0.0.1"), 10033);
    let listener: tokio::net::TcpListener;
    match tokio::net::TcpListener::bind(host).await {
        Ok(result) => listener = result,
        Err(error) => {
            eprintln!("Failed connet to database. err: {:?}", error);
            return;
        }
    }
    println!("server running");
    match axum::serve(listener, route).await {
        Ok(_) => {}
        Err(error) => {
            eprintln!("faile serve. error: {:}", error)
        }
    }
}
