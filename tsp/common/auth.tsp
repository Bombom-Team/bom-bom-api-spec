import "@typespec/http";
import "@typespec/openapi";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace BomBomAPI;

@doc("세션 쿠키 기반 인증")
@useRef("#/components/securitySchemes/sessionCookie")
model sessionCookie is ApiKeyAuth<ApiKeyLocation.cookie, "JSESSIONID">;
