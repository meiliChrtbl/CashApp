class Member {
  final int id;
  final String nama;
  final String nik;
  final String email;
  final String password;

  Member(
    {required this.id, 
    required this.nama, 
    required this.nik, 
    required this.email, 
    required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nik': nik,
      'email': email, 
      'password': password,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      nama: map['nama'],
      nik: map['nik'],
      email: map['email'], 
      password: map['password'],
    );
  }
}