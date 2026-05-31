import "@typespec/http";
import "@typespec/openapi";

import "../common/auth.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace BomBomAPI;

@doc("증감 방향")
enum ChangeDirection {
  UP,
  DOWN,
  SAME,
}

@doc("가입일 기준 읽기 D-Day 정보")
model ReadingDDayResponse {
  @doc("가입일 이래로 지난 일수")
  daysSinceJoined: int32;

  @doc("가입일 (yyyy-MM-dd)")
  joinedAt: plainDate;
}

@doc("읽기 캘린더의 하루 정보")
model ReadingCalendarDayResponse {
  @doc("날짜 (yyyy-MM-dd)")
  date: plainDate;

  @doc("해당 날짜에 아티클을 읽었는지 여부")
  read: boolean;

  @doc("해당 날짜에 읽은 아티클 수")
  readCount: int32;
}

@doc("월간 읽기 캘린더 응답")
model ReadingCalendarResponse {
  @doc("일자별 읽기 현황")
  days: ReadingCalendarDayResponse[];
}

@doc("월간 읽은 아티클 통계")
model ReadingDashboardReadArticles {
  @doc("이번 달 읽은 아티클 수")
  count: int32;

  @doc("지난 달 대비 증감률 (%)")
  changeRate: float64;

  @doc("지난 달 대비 증감 방향")
  changeDirection: ChangeDirection;
}

@doc("북마크 통계")
model ReadingDashboardBookmarks {
  @doc("북마크 개수")
  count: int32;
}

@doc("자주 읽은 뉴스레터 정보")
model FrequentReadNewsletterResponse {
  @doc("순위 (1-base)")
  rank: int32;

  @doc("뉴스레터 ID")
  newsletterId: int64;

  @doc("뉴스레터명")
  name: string;

  @doc("이번 달 읽은 아티클 수")
  readCount: int32;
}

@doc("월간 읽기 대시보드 응답")
model ReadingDashboardResponse {
  @doc("월간 읽은 아티클 통계")
  readArticles: ReadingDashboardReadArticles;

  @doc("북마크 통계")
  bookmarks: ReadingDashboardBookmarks;

  @doc("자주 읽은 뉴스레터 TOP")
  frequentReadNewsletters: FrequentReadNewsletterResponse[];
}

@doc("읽기 D-Day 조회 성공")
model GetReadingDDayOk {
  @statusCode statusCode: 200;
  @body body: ReadingDDayResponse;
}

@doc("인증 실패")
model GetReadingDDayUnauthorized {
  @statusCode statusCode: 401;
}

@doc("읽기 캘린더 조회 성공")
model GetReadingCalendarOk {
  @statusCode statusCode: 200;
  @body body: ReadingCalendarResponse;
}

@doc("잘못된 연·월 파라미터 요청")
model GetReadingCalendarBadRequest {
  @statusCode statusCode: 400;
}

@doc("인증 실패")
model GetReadingCalendarUnauthorized {
  @statusCode statusCode: 401;
}

@doc("읽기 대시보드 조회 성공")
model GetReadingDashboardOk {
  @statusCode statusCode: 200;
  @body body: ReadingDashboardResponse;
}

@doc("잘못된 연·월 파라미터 요청")
model GetReadingDashboardBadRequest {
  @statusCode statusCode: 400;
}

@doc("인증 실패")
model GetReadingDashboardUnauthorized {
  @statusCode statusCode: 401;
}

@tag("Reading")
@route("/api/v1/members/me/reading")
namespace Reading {
  @summary("읽기 D-Day 조회")
  @doc("로그인한 회원의 가입일 이래로 지난 일수를 조회합니다.")
  @operationId("getReadingDDay")
  @useAuth(sessionCookie)
  @extension("x-needs-login-member", true)
  @get
  @route("/d-day")
  op getReadingDDay(): GetReadingDDayOk | GetReadingDDayUnauthorized;

  @summary("월간 읽기 캘린더 조회")
  @doc("로그인한 회원의 해당 연·월 일자별 읽기 현황을 조회합니다.")
  @operationId("getReadingCalendar")
  @useAuth(sessionCookie)
  @extension("x-needs-login-member", true)
  @get
  @route("/calendar")
  op getReadingCalendar(
    @doc("조회할 연도")
    @minValue(1)
    @extension("x-message", "year는 1 이상의 값이어야 합니다.")
    @query
    year: int32,

    @doc("조회할 월 (1-12)")
    @minValue(1)
    @maxValue(12)
    @extension("x-message", "month는 1 이상 12 이하의 값이어야 합니다.")
    @query
    month: int32,
  ): GetReadingCalendarOk | GetReadingCalendarBadRequest | GetReadingCalendarUnauthorized;

  @summary("월간 읽기 대시보드 조회")
  @doc("""
    로그인한 회원의 해당 연·월 읽기 통계를 조회합니다.
    읽은 아티클 수(지난 달 대비 증감 포함), 북마크 수, 자주 읽은 뉴스레터를 반환합니다.
    """)
  @operationId("getReadingDashboard")
  @useAuth(sessionCookie)
  @extension("x-needs-login-member", true)
  @get
  @route("/dashboard")
  op getReadingDashboard(
    @doc("조회할 연도")
    @minValue(1)
    @extension("x-message", "year는 1 이상의 값이어야 합니다.")
    @query
    year: int32,

    @doc("조회할 월 (1-12)")
    @minValue(1)
    @maxValue(12)
    @extension("x-message", "month는 1 이상 12 이하의 값이어야 합니다.")
    @query
    month: int32,
  ): GetReadingDashboardOk | GetReadingDashboardBadRequest | GetReadingDashboardUnauthorized;
}
