use config::{Config, ConfigError, File, FileFormat};
use serde::Deserialize;

#[derive(Debug, Clone)]
pub struct AppState {
    pub service_name: String,
}

#[derive(Debug, Deserialize)]
pub struct Application {
    pub name: String,
    pub service: Service,
}

#[derive(Debug, Deserialize)]
pub struct Service {
    pub host: String,
    pub port: i16,
}

pub fn new_config() -> Result<Application, ConfigError> {
    let create_config: Config;
    match Config::builder()
        .add_source(File::new(
            "./src/delivery/applicationSetting.toml",
            FileFormat::Toml,
        ))
        .build()
    {
        Ok(result) => create_config = result,
        Err(error) => return Err(error),
    }

    let app: Application;
    match create_config.try_deserialize() {
        Ok(ok) => app = ok,
        Err(error) => return Err(error),
    }

    Ok(app)
}
