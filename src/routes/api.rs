use crate::delivery;

use axum::{
    Router,
    body::{Body, Bytes},
    extract::{Request, State},
    http::header,
    response::Response,
    routing::{IntoMakeService, get},
};
use delivery::AppState;
use std::{sync::Arc, time::Duration};
use tower::ServiceBuilder;
use tower_http::{
    classify::ServerErrorsFailureClass,
    sensitive_headers::{SetSensitiveRequestHeadersLayer, SetSensitiveResponseHeadersLayer},
    timeout::TimeoutLayer,
    trace::{DefaultMakeSpan, TraceLayer},
};

pub fn apis(state: AppState) -> IntoMakeService<Router> {
    let sensitive_headers: Arc<[_]> = Arc::new([header::AUTHORIZATION, header::COOKIE]);
    let logger = ServiceBuilder::new()
        .layer(SetSensitiveRequestHeadersLayer::from_shared(Arc::clone(
            &sensitive_headers,
        )))
        .layer(
            TraceLayer::new_for_http()
                .make_span_with(DefaultMakeSpan::new().include_headers(true))
                .on_body_chunk(|chunk: &Bytes, latency: Duration, _: &tracing::Span| {
                    tracing::info!(size_body = chunk.len(), latency = ?latency, "sending body chunk")
                })
                .on_request(|request: &Request, _span: &tracing::Span| {
                    tracing::info!("started {} {}", request.method(), request.uri().path())
                })
                .on_response(|response: &Response<Body>, latency: Duration, _span: &tracing::Span| {
                    tracing::info!(status_response = ?response.status(), latency = ?latency,"response finish")
                })
                .on_failure(|error_response: ServerErrorsFailureClass, latency: Duration, _span: &tracing::Span| {
                    match error_response {
                        ServerErrorsFailureClass::StatusCode(code) => {
                            tracing::error!(latency = ?latency, "response finish but got error with status code: {:?}", code)
                        }
                        ServerErrorsFailureClass::Error(error) => {
                            tracing::error!(latency = ?latency, "response finish but got error: {:?}", error)
                        }
                    }
                })
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
