import "@typespec/http";
import "@typespec/openapi";

import "../../common/auth.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace BomBomAPI;

@doc("마이페이지 랭킹 히스토리 정보")
model RankHistoryResponse {
  @doc("랭킹 기준 월 (yyyy-MM)")
  month: string;

  @doc("화면 표시용 월 라벨")
  label: string;

  @doc("해당 월의 순위")
  @extension("x-java-primitive", true)
  rank: int64;
}

@doc("마이페이지 랭킹 카드 정보")
model RankCardResponse {
  @doc("랭킹 타입 (streak: 연속 읽기, reading: 다독왕)")
  type: string;

  @doc("이전달까지의 최신 확정 순위. 랭킹 이력이 없으면 null입니다.")
  currentRank: int64 | null;

  rankHistory: RankHistoryResponse[];

  @doc("카드 표시 값. streak는 현재 연속 읽기 일수, reading은 누적 읽은 아티클 수입니다.")
  value: int32;
}

@doc("마이페이지 랭킹 요약 응답")
model RankSummaryResponse {
  cards: RankCardResponse[];
}

alias RankSummaryQuery = {
  @doc("랭킹 타입 (streak 또는 reading). 생략하면 모든 랭킹 카드를 반환합니다.")
  @query
  type?: string;
};

@doc("마이페이지 랭킹 요약 조회 성공")
model GetRankSummaryOk {
  @statusCode statusCode: 200;
  @body body: RankSummaryResponse;
}

@doc("잘못된 랭킹 타입 요청")
model GetRankSummaryBadRequest {
  @statusCode statusCode: 400;
}

@doc("인증 실패")
model GetRankSummaryUnauthorized {
  @statusCode statusCode: 401;
}

@tag("MyPage")
@route("/api/v1/members/me")
namespace MyPage {
  @summary("마이페이지 랭킹 요약 조회")
  @doc("""
    로그인한 회원의 마이페이지 랭킹 카드를 조회합니다.
    rankHistory와 currentRank는 현재월을 제외한 이전달까지의 확정 랭킹을 기준으로 합니다.
    reading 카드의 value는 누적 읽은 아티클 수, streak 카드의 value는 현재 연속 읽기 일수입니다.
    """)
  @operationId("getRankSummary")
  @useAuth(sessionCookie)
  @extension("x-needs-login-member", true)
  @get
  @route("/rank")
  op getRankSummary(
    ...RankSummaryQuery,
  ): GetRankSummaryOk | GetRankSummaryBadRequest | GetRankSummaryUnauthorized;
}
