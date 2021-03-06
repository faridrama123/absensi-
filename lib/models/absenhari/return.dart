///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class ReturnAbsenHariAbsen_out {
/*
{
  "id": "2",
  "iduser": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
  "tipe_absen": "1",
  "datang_pulang": "out",
  "wfh_wfo": "wfh",
  "tanggal_absen": "2021-08-30",
  "jam_absen": "02:54:02",
  "lokasi": "Jalan PU 35, Cimuning, Kecamatan Mustika Jaya, Kota Bekasi, Jawa Barat 17154, Indonesia",
  "latitude": "-6.34",
  "longitude": "107.020889",
  "keterangan": null,
  "created_at": "2021-08-30 13:33:28",
  "created_by": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
  "updated_at": "2021-08-30 13:33:37",
  "updated_by": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
  "trash": "0"
} 
*/

  String? id;
  String? iduser;
  String? tipe_absen;
  String? datang_pulang;
  String? wfh_wfo;
  String? tanggal_absen;
  String? jam_absen;
  String? lokasi;
  String? latitude;
  String? longitude;
  String? keterangan;
  String? created_at;
  String? created_by;
  String? updated_at;
  String? updated_by;
  String? trash;

  ReturnAbsenHariAbsen_out({
    this.id,
    this.iduser,
    this.tipe_absen,
    this.datang_pulang,
    this.wfh_wfo,
    this.tanggal_absen,
    this.jam_absen,
    this.lokasi,
    this.latitude,
    this.longitude,
    this.keterangan,
    this.created_at,
    this.created_by,
    this.updated_at,
    this.updated_by,
    this.trash,
  });
  ReturnAbsenHariAbsen_out.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    iduser = json["iduser"]?.toString();
    tipe_absen = json["tipe_absen"]?.toString();
    datang_pulang = json["datang_pulang"]?.toString();
    wfh_wfo = json["wfh_wfo"]?.toString();
    tanggal_absen = json["tanggal_absen"]?.toString();
    jam_absen = json["jam_absen"]?.toString();
    lokasi = json["lokasi"]?.toString();
    latitude = json["latitude"]?.toString();
    longitude = json["longitude"]?.toString();
    keterangan = json["keterangan"]?.toString();
    created_at = json["created_at"]?.toString();
    created_by = json["created_by"]?.toString();
    updated_at = json["updated_at"]?.toString();
    updated_by = json["updated_by"]?.toString();
    trash = json["trash"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["iduser"] = iduser;
    data["tipe_absen"] = tipe_absen;
    data["datang_pulang"] = datang_pulang;
    data["wfh_wfo"] = wfh_wfo;
    data["tanggal_absen"] = tanggal_absen;
    data["jam_absen"] = jam_absen;
    data["lokasi"] = lokasi;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["keterangan"] = keterangan;
    data["created_at"] = created_at;
    data["created_by"] = created_by;
    data["updated_at"] = updated_at;
    data["updated_by"] = updated_by;
    data["trash"] = trash;
    return data;
  }
}

class ReturnAbsenHariAbsen_in {
/*
{
  "id": "1",
  "iduser": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
  "tipe_absen": "1",
  "datang_pulang": "in",
  "wfh_wfo": "wfh",
  "tanggal_absen": "2021-08-30",
  "jam_absen": "02:54:02",
  "lokasi": "Jalan PU 35, Cimuning, Kecamatan Mustika Jaya, Kota Bekasi, Jawa Barat 17154, Indonesia",
  "latitude": "-6.34",
  "longitude": "107.020889",
  "keterangan": null,
  "created_at": "2021-08-30 13:28:14",
  "created_by": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
  "updated_at": "2021-08-30 13:29:01",
  "updated_by": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
  "trash": "0"
} 
*/

  String? id;
  String? iduser;
  String? tipe_absen;
  String? datang_pulang;
  String? wfh_wfo;
  String? tanggal_absen;
  String? jam_absen;
  String? lokasi;
  String? latitude;
  String? longitude;
  String? keterangan;
  String? created_at;
  String? created_by;
  String? updated_at;
  String? updated_by;
  String? trash;

  ReturnAbsenHariAbsen_in({
    this.id,
    this.iduser,
    this.tipe_absen,
    this.datang_pulang,
    this.wfh_wfo,
    this.tanggal_absen,
    this.jam_absen,
    this.lokasi,
    this.latitude,
    this.longitude,
    this.keterangan,
    this.created_at,
    this.created_by,
    this.updated_at,
    this.updated_by,
    this.trash,
  });
  ReturnAbsenHariAbsen_in.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    iduser = json["iduser"]?.toString();
    tipe_absen = json["tipe_absen"]?.toString();
    datang_pulang = json["datang_pulang"]?.toString();
    wfh_wfo = json["wfh_wfo"]?.toString();
    tanggal_absen = json["tanggal_absen"]?.toString();
    jam_absen = json["jam_absen"]?.toString();
    lokasi = json["lokasi"]?.toString();
    latitude = json["latitude"]?.toString();
    longitude = json["longitude"]?.toString();
    keterangan = json["keterangan"]?.toString();
    created_at = json["created_at"]?.toString();
    created_by = json["created_by"]?.toString();
    updated_at = json["updated_at"]?.toString();
    updated_by = json["updated_by"]?.toString();
    trash = json["trash"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["iduser"] = iduser;
    data["tipe_absen"] = tipe_absen;
    data["datang_pulang"] = datang_pulang;
    data["wfh_wfo"] = wfh_wfo;
    data["tanggal_absen"] = tanggal_absen;
    data["jam_absen"] = jam_absen;
    data["lokasi"] = lokasi;
    data["latitude"] = latitude;
    data["longitude"] = longitude;
    data["keterangan"] = keterangan;
    data["created_at"] = created_at;
    data["created_by"] = created_by;
    data["updated_at"] = updated_at;
    data["updated_by"] = updated_by;
    data["trash"] = trash;
    return data;
  }
}

class ReturnAbsenHari {
/*
{
  "status_json": true,
  "remarks": "Berhasil",
  "hari": "Senin",
  "tanggal": "30",
  "bulantahun": "08/2021",
  "absen_in": {
    "id": "1",
    "iduser": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
    "tipe_absen": "1",
    "datang_pulang": "in",
    "wfh_wfo": "wfh",
    "tanggal_absen": "2021-08-30",
    "jam_absen": "02:54:02",
    "lokasi": "Jalan PU 35, Cimuning, Kecamatan Mustika Jaya, Kota Bekasi, Jawa Barat 17154, Indonesia",
    "latitude": "-6.34",
    "longitude": "107.020889",
    "keterangan": null,
    "created_at": "2021-08-30 13:28:14",
    "created_by": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
    "updated_at": "2021-08-30 13:29:01",
    "updated_by": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
    "trash": "0"
  },
  "absen_out": {
    "id": "2",
    "iduser": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
    "tipe_absen": "1",
    "datang_pulang": "out",
    "wfh_wfo": "wfh",
    "tanggal_absen": "2021-08-30",
    "jam_absen": "02:54:02",
    "lokasi": "Jalan PU 35, Cimuning, Kecamatan Mustika Jaya, Kota Bekasi, Jawa Barat 17154, Indonesia",
    "latitude": "-6.34",
    "longitude": "107.020889",
    "keterangan": null,
    "created_at": "2021-08-30 13:33:28",
    "created_by": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
    "updated_at": "2021-08-30 13:33:37",
    "updated_by": "EB8BA43C-7973-4A44-A1E6-9F1D9BE180DA",
    "trash": "0"
  }
} 
*/

  bool? status_json;
  String? remarks;
  String? hari;
  String? tanggal;
  String? bulantahun;
  ReturnAbsenHariAbsen_in? absen_in;
  ReturnAbsenHariAbsen_out? absen_out;

  ReturnAbsenHari({
    this.status_json,
    this.remarks,
    this.hari,
    this.tanggal,
    this.bulantahun,
    this.absen_in,
    this.absen_out,
  });
  ReturnAbsenHari.fromJson(Map<String, dynamic> json) {
    status_json = json["status_json"];
    remarks = json["remarks"]?.toString();
    hari = json["hari"]?.toString();
    tanggal = json["tanggal"]?.toString();
    bulantahun = json["bulantahun"]?.toString();
    absen_in = (json["absen_in"] != null)
        ? ReturnAbsenHariAbsen_in.fromJson(json["absen_in"])
        : null;
    absen_out = (json["absen_out"] != null)
        ? ReturnAbsenHariAbsen_out.fromJson(json["absen_out"])
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["status_json"] = status_json;
    data["remarks"] = remarks;
    data["hari"] = hari;
    data["tanggal"] = tanggal;
    data["bulantahun"] = bulantahun;
    if (absen_in != null) {
      data["absen_in"] = absen_in!.toJson();
    }
    if (absen_out != null) {
      data["absen_out"] = absen_out!.toJson();
    }
    return data;
  }
}
