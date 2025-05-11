use std::net::SocketAddr;
use axum::Router;
use tower_http::services::ServeFile;
use tower_http::trace::TraceLayer;

#[tokio::main]
async fn main() {
    tokio::join!(
        serve(using_serve_file_from_a_route(), 8080),
    );
}

fn using_serve_file_from_a_route() -> Router {
    Router::new().route_service("/", ServeFile::new("assets/index.html"))
}

async fn serve(app: Router, port: u16) {
    let addr = SocketAddr::from(([0, 0, 0, 0], port));
    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    tracing::debug!("Listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app.layer(TraceLayer::new_for_http()))
        .await
        .unwrap();
}
