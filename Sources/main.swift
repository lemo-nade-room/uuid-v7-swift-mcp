import Foundation
import Logging
import MCP

let server = Server(name: "UUID v7 Generator", version: "1.0.0")
let transport = StdioTransport()

enum UUIDv7を生成: Sendable {
    static let name = "generate_uuid_v7"
    static let tool: MCP.Tool = .init(
        name: Self.name,
        description:
            "UUIDv7を指定されたcountの数だけ生成し、[UUID]を返します。countが指定されない場合1つだけ生成します。",
        inputSchema: .object([
            "type": "object",
            "properties": [
                "count": [
                    "description": "生成するUUIDの個数。1以上またはnil",
                    "type": "number",
                ]
            ],
        ])
    )
    static func handle(params: CallTool.Parameters) async throws -> CallTool.Result {
        let count = params.arguments?["count"]?.intValue ?? 1
        guard count >= 1 else {
            throw MCPError.invalidParams("countはnilまたは1以上である必要があります。")
        }

        let result = [UUID](repeating: .v7(now: Date()), count: count)
        return .init(content: [.text("\(result)")])
    }
}

await server.withMethodHandler(ListResources.self) { _ in .init(resources: []) }
await server.withMethodHandler(ListPrompts.self) { _ in .init(prompts: []) }
await server.withMethodHandler(ListTools.self) { params in
    .init(tools: [UUIDv7を生成.tool])
}
await server.withMethodHandler(CallTool.self) { params in
    switch params.name {
    case UUIDv7を生成.name: try await UUIDv7を生成.handle(params: params)
    default: throw MCPError.methodNotFound(nil)
    }
}

try await server.start(transport: transport)
await server.waitUntilCompleted()
