import "@typespec/http";
import "@typespec/openapi";

import "../common/auth.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace BomBomAPI;

@doc("펫 정보")
model PetResponse {
  @doc("펫 레벨")
  level: int32;

  @doc("현재 스테이지 점수")
  currentStageScore: int32;

  @doc("필요한 스테이지 점수")
  requiredStageScore: int32;

  @doc("출석 여부")
  isAttended: boolean;
}

@doc("펫 정보 조회 성공")
model GetPetOk {
  @statusCode statusCode: 200;
  @body body: PetResponse;
}

@doc("출석 점수 부여 성공")
model AttendOk {
  @statusCode statusCode: 200;
}

@doc("인증 실패")
model UnauthorizedResponse {
  @statusCode statusCode: 401;
}

@tag("Pet")
@route("/api/v1/members/me/pet")
namespace Pet {
  @summary("내 펫 정보 조회")
  @doc("현재 로그인한 사용자의 펫 정보를 조회합니다.")
  @operationId("getPet")
  @useAuth(sessionCookie)
  @extension("x-needs-login-member", true)
  @get
  op getPet(): GetPetOk | UnauthorizedResponse;

  @summary("출석 점수 부여")
  @doc("오늘의 출석 점수를 펫에게 부여합니다.")
  @operationId("attend")
  @useAuth(sessionCookie)
  @extension("x-needs-login-member", true)
  @route("/attendance")
  @post
  op attend(): AttendOk | UnauthorizedResponse;
}
