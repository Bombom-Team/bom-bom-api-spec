import "@typespec/http";
import "@typespec/openapi";

import "../../common/auth.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace BomBomAPI;

@doc("회원 가입일 기준 경과일 정보")
model MemberJoinDaysResponse {
  @doc("가입일 이래로 지난 일수")
  daysSinceJoined: int32;

  @doc("가입일 (yyyy-MM-dd)")
  joinedAt: plainDate;
}

@doc("회원 가입일 기준 경과일 조회 성공")
model GetMemberJoinDaysOk {
  @statusCode statusCode: 200;
  @body body: MemberJoinDaysResponse;
}

@doc("인증 실패")
model GetMemberJoinDaysUnauthorized {
  @statusCode statusCode: 401;
}

@tag("MyPage")
@route("/api/v1/members/me")
namespace MyPage {
  @summary("회원 가입일 기준 경과일 조회")
  @doc("로그인한 회원의 가입일과 가입일 이래로 지난 일수를 조회합니다.")
  @operationId("getMemberJoinDays")
  @useAuth(sessionCookie)
  @extension("x-needs-login-member", true)
  @get
  @route("/join-days")
  op getMemberJoinDays(): GetMemberJoinDaysOk | GetMemberJoinDaysUnauthorized;
}
