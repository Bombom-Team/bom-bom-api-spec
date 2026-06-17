import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./common/auth.tsp";
import "./common/pagination.tsp";
import "./domains/mypage/mypage.tsp";
import "./domains/mypage/monthlyreport.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

@service({
  title: "BomBom API",
})
@info({
  version: "1.0.0",
})
@server("https://api.bombom.news", "BomBom Production API")
@tagMetadata("MyPage", #{description: "마이페이지 관련 API"})
@tagMetadata("MonthlyReport", #{description: "월간 리포트 관련 API"})
namespace BomBomAPI;
