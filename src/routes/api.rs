use axum::{
    Router,
    routing::{IntoMakeService, get},
};

pub fn apis() -> IntoMakeService<Router> {
    let app_route = Router::new().route("/", get(|| async { "Hello, World!" }));
    app_route.into_make_service()
}
