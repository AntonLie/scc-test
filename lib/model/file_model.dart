class FileModel {
  String? fileName;
  String? fileType;
  String? fileBase64;
  String? base64;
  String? byteArray;

  FileModel(
      {this.fileName,
      this.fileType,
      this.fileBase64,
      this.byteArray,
      this.base64});

  FileModel.map(Map<String, dynamic> obj) {
    fileName = obj['fileName'];
    fileType = obj['fileType'];
    fileBase64 = obj['fileBase64'];
    base64 = obj['base64'];
    byteArray = obj['byteArray'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['fileName'] = fileName;
    data['fileType'] = fileType;
    data['fileBase64'] = fileBase64;
    data['base64'] = base64;
    data['byteArray'] = byteArray;
    return data;
  }
}
