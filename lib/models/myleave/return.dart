class ReturnMyLeave {
  ReturnMyLeave({
    required this.statusJson,
    required this.remarks,
    required this.listleave,
  });
  late final bool statusJson;
  late final String remarks;
  late final List<Listleave> listleave;

  ReturnMyLeave.fromJson(Map<String, dynamic> json) {
    statusJson = json['status_json'];
    remarks = json['remarks'];
    listleave =
        List.from(json['listleave']).map((e) => Listleave.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status_json'] = statusJson;
    _data['remarks'] = remarks;
    _data['listleave'] = listleave.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Listleave {
  Listleave({
    required this.id,
    required this.staffId,
    required this.tanggal,
    required this.ket,
    required this.status,
    required this.tipe,
    required this.mulai,
    required this.akhir,
    required this.jamMulai,
    required this.jamAkhir,
  });
  late final String id;
  late final String staffId;
  late final String tanggal;
  late final String ket;
  late final int status;
  late final String tipe;
  late final String mulai;
  late final String akhir;
  late final String jamMulai;
  late final String jamAkhir;

  Listleave.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staffId = json['staff_id'];
    tanggal = json['tanggal'];
    ket = json['ket'];
    status = json['status'];
    tipe = json['tipe'];
    mulai = json['mulai'];
    akhir = json['akhir'];
    jamMulai = json['jam_mulai'];
    jamAkhir = json['jam_akhir'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['staff_id'] = staffId;
    _data['tanggal'] = tanggal;
    _data['ket'] = ket;
    _data['status'] = status;
    _data['tipe'] = tipe;
    _data['mulai'] = mulai;
    _data['akhir'] = akhir;
    _data['jam_mulai'] = jamMulai;
    _data['jam_akhir'] = jamAkhir;
    return _data;
  }
}
