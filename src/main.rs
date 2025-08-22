use tracing::Level;
use tracing_subscriber::FmtSubscriber;

mod delivery;
#[path = "./routes/api.rs"]
mod route_api;

#[tokio::main]
async fn main() {
    let version = env!("CARGO_PKG_VERSION");
    tracing::info!("version service: {:}", version);

    // initial tracing for log
    let fmt_sub = FmtSubscriber::builder()
        .with_max_level(Level::INFO)
        .finish();
    tracing::subscriber::set_global_default(fmt_sub).expect("error initial tracing subscribe");

    // setup environment
    let env_app: delivery::Application;
    match delivery::new_config() {
        Ok(res) => env_app = res,
        Err(error) => panic!("Error environment: {:}", error),
    }

    let state: delivery::AppState = delivery::AppState {
        service_name: env_app.name.clone(),
    };
    let route = route_api::apis(state);
    let host = format!("{}:{}", env_app.service.host, env_app.service.port);
    let listener: tokio::net::TcpListener;
    match tokio::net::TcpListener::bind(host).await {
        Ok(result) => listener = result,
        Err(error) => {
            eprintln!("Failed connet to database. err: {:?}", error);
            return;
        }
    }
    tracing::info!("service {:} are running", env_app.name);
    tracing::info!("listen on {:?}", listener.local_addr());
    match axum::serve(listener, route).await {
        Ok(_) => {}
        Err(error) => {
            eprintln!("faile serve. error: {:}", error)
        }
    }
}
