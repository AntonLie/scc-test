class Paging {
  int? pageNo;
  int? pageSize;
  int? totalDataInPage;
  int? packageCd;
  int? totalData;
  int? totalPages;

  Paging(
      {this.pageNo,
      this.pageSize,
      this.totalDataInPage,
      this.packageCd,
      this.totalData,
      this.totalPages});

  Paging.map(Map<String, dynamic> obj) {
    pageNo = obj['pageNo'];
    pageSize = obj['pageSize'];
    totalDataInPage = obj['totalDataInPage'];
    totalData = obj['totalData'];
    totalPages = obj['totalPages'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = {};
    data['pageNo'] = (pageNo ?? "").toString();
    data['pageSize'] = (pageSize ?? "").toString();
    return data;
  }

  Map<String, String> toSubs() {
    final Map<String, String> data = {};
    data['pageNo'] = (pageNo ?? "").toString();
    data['pageSize'] = (pageSize ?? "").toString();
    data['packageCd'] = (packageCd ?? "").toString();
    return data;
  }
}
