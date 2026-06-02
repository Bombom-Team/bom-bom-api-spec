import "@typespec/http";

using TypeSpec.Http;

namespace BomBomAPI;

@doc("세션 쿠키 기반 인증")
model sessionCookie is ApiKeyAuth<ApiKeyLocation.cookie, "JSESSIONID">;
