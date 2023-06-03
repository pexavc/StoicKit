import Fluent
import Vapor


func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    try app.register(collection: ThinkController(loopGroup: app.eventLoopGroup))
    try app.register(collection: MarqueController(loopGroup: app.eventLoopGroup))
}
