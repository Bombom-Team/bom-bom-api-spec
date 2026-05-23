import "@typespec/http";
import "@typespec/openapi";

import "../common/auth.tsp";
import "../common/pagination.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace BomBomAPI;

@doc("뉴스레터 요약 정보")
model NewsletterSummaryResponse {
  @doc("뉴스레터명")
  name: string;

  @doc("이미지 URL")
  imageUrl?: string | null;

  @doc("카테고리")
  category: string;
}

@doc("아티클 정보")
model ArticleResponse {
  @doc("아티클 ID")
  articleId: int64;

  @doc("아티클 제목")
  title: string;

  @doc("본문 요약")
  contentsSummary: string;

  @doc("도착 일시")
  arrivedDateTime: utcDateTime;

  @doc("썸네일 이미지 URL")
  thumbnailUrl?: string | null;

  @doc("예상 읽기 시간 (분)")
  expectedReadTime: int32;

  @doc("읽음 여부")
  isRead: boolean;

  @doc("북마크 여부")
  isBookmarked: boolean;

  newsletter: NewsletterSummaryResponse;
}

@doc("페이징된 아티클 목록 응답")
model PageArticleResponse is Page<ArticleResponse>;

@doc("아티클 목록 조회 성공")
model GetArticlesOk {
  @statusCode statusCode: 200;
  @body body: PageArticleResponse;
}

@doc("잘못된 정렬 파라미터 요청")
model GetArticlesBadRequest {
  @statusCode statusCode: 400;
}

@doc("인증 실패")
model GetArticlesUnauthorized {
  @statusCode statusCode: 401;
}

@tag("Article")
@route("/api/v1/articles")
namespace Articles {
  @summary("아티클 목록 조회")
  @doc("""
    조건에 맞는 아티클 목록을 페이징하여 조회합니다.
    (정렬 기본값: ?page=0&size=10&sort=arrivedDateTime,desc)
    """)
  @operationId("getArticles")
  @useAuth(sessionCookie)
  @extension("x-spring-paginated", true)
  @extension("x-needs-login-member", true)
  @get
  op getArticles(
    @doc("필터링할 도착 날짜 (yyyy-MM-dd)")
    @query
    date?: plainDate,

    @doc("필터링할 뉴스레터 ID")
    @minValue(1)
    @extension("x-message", "id는 1 이상의 값이어야 합니다.")
    @query
    newsletterId?: int64,
  ): GetArticlesOk | GetArticlesBadRequest | GetArticlesUnauthorized;
}
