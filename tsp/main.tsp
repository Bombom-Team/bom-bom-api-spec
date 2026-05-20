import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./common/auth.tsp";
import "./common/pagination.tsp";
import "./domains/article.tsp";
import "./domains/pet.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

@service({
  title: "BomBom API",
})
@info({
  version: "1.0.0",
})
@server("https://api.bombom.news", "BomBom Production API")
namespace BomBomAPI;
