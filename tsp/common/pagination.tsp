import "@typespec/http";
import "@typespec/openapi";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace BomBomAPI;

@doc("Spring Data 페이징 응답")
model Page<T> {
  @doc("현재 페이지 데이터")
  content: T[];

  @doc("전체 데이터 개수")
  totalElements: int64;

  @doc("전체 페이지 수")
  totalPages: int32;

  @doc("현재 페이지 번호 (0-base)")
  number: int32;

  @doc("페이지 크기")
  size: int32;

  @doc("현재 페이지 데이터 개수")
  numberOfElements: int32;

  @doc("첫 페이지 여부")
  first: boolean;

  @doc("마지막 페이지 여부")
  last: boolean;
}
