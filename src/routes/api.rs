use crate::delivery;

use axum::{
    Router,
    body::Bytes,
    extract::State,
    http::header,
    routing::{IntoMakeService, get},
};
use delivery::AppState;
use std::{sync::Arc, time::Duration};
use tower::ServiceBuilder;
use tower_http::{
    LatencyUnit,
    sensitive_headers::{SetSensitiveRequestHeadersLayer, SetSensitiveResponseHeadersLayer},
    timeout::TimeoutLayer,
    trace::{DefaultMakeSpan, DefaultOnResponse, TraceLayer},
};

pub fn apis(state: AppState) -> IntoMakeService<Router> {
    let sensitive_headers: Arc<[_]> = Arc::new([header::AUTHORIZATION, header::COOKIE]);
    let logger = ServiceBuilder::new()
        .layer(SetSensitiveRequestHeadersLayer::from_shared(Arc::clone(
            &sensitive_headers,
        )))
        .layer(
            TraceLayer::new_for_http()
                .on_body_chunk(|chunk: &Bytes, latency: Duration, _: &tracing::Span| {
                    tracing::info!(size_bytes = chunk.len(), latency = ?latency, "sending body chunk")
                })
                .make_span_with(DefaultMakeSpan::new().include_headers(true))
                .on_response(DefaultOnResponse::new().include_headers(true).latency_unit(LatencyUnit::Micros))
        )
        .layer(SetSensitiveResponseHeadersLayer::from_shared(
            sensitive_headers,
        ))
        .layer(TimeoutLayer::new(Duration::from_secs(10)));

    let app_route = Router::new()
        .route("/", get(welcome))
        .layer(logger)
        .with_state(state);
    app_route.into_make_service()
}

async fn welcome(state: State<AppState>) -> String {
    format!("Welcome to service {:}", state.service_name)
}
