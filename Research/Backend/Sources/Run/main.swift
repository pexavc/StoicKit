import App
import Vapor


let corsConfiguration = CORSMiddleware.Configuration(
    allowedOrigin: .all,
    allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
    allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
)
let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
app.middleware.use(corsMiddleware)
defer { app.shutdown() }
try configure(app)
try app.run()
