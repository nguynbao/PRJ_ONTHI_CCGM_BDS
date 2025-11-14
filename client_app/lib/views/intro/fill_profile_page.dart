import 'package:client_app/common/app_button.dart';
import 'package:client_app/config/assets/app_images.dart';
import 'package:client_app/config/routes/app_navigator.dart';
import 'package:client_app/config/themes/app_color.dart';
import 'package:client_app/controllers/auth.controller.dart';
import 'package:client_app/views/intro/signin_page.dart'; // Import trang Signin
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart'; 

class FillProfilePage extends StatefulWidget {
  final String email;
  final String password;

  const FillProfilePage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<FillProfilePage> createState() => _FillProfilePageState();
}

class _FillProfilePageState extends State<FillProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  DateTime? _selectedDate; // Ngày sinh
  String? _selectedGender; // Giới tính
  final List<String> _genders = ['Male', 'Female', 'Other']; 

  final _auth = AuthController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ---- VALIDATORS ----
  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Full name is required';
    return null;
  }
  
  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone is required';
    if (v.trim().length < 8) return 'Invalid phone number';
    return null;
  }
  
  // ---- DATE PICKER HANDLER ----
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // ---- FINAL SIGN UP STEP ----
  Future<void> _onFinishSignup() async {
    final formOk = _formKey.currentState?.validate() ?? false;

    // Kiểm tra các trường dữ liệu chi tiết
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your Date of Birth')),
      );
      return;
    }
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your Gender')),
      );
      return;
    }
    
    if (!formOk) return;

    setState(() => _loading = true);
    try {
      // 🔥 BƯỚC 2: GỌI HÀM REGISTER CUỐI CÙNG ĐỂ TẠO TÀI KHOẢN VÀ LƯU PROFILE
      await _auth.register(
        email: widget.email,
        password: widget.password,
        userName: _nameController.text.trim(),
        bod: _selectedDate!, 
        gender: _selectedGender!,
        phone: _phoneController.text.trim(), // Thêm trường phone vào UserModel và hàm register
      );

      if (!mounted) return;

      // Thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      
      // Chuyển hướng về màn hình đăng nhập 
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SigninPage()),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed: ${e.toString().replaceFirst('Exception: ', '')}')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  
  // --- BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              AppNavigator.pop(context);
            },
            icon: Icon(
              Iconsax.arrow_left,
              size: 30,
              color: AppColor.textpriCol,
            ),
          ),
          title: const Text(
            'Fill Your Profile',
            style: TextStyle(
              color: AppColor.textpriCol,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _editAvt(),
                  const SizedBox(height: 24),
                  
                  _textFieldFullName(context), // Tên người dùng (userName)
                  const SizedBox(height: 16),
                  
                  _dateOfBirthField(context), // Ngày sinh (bod)
                  const SizedBox(height: 16),

                  _textFieldEmail(context), // Email (Hiển thị)
                  const SizedBox(height: 16),
                  
                  _textFieldPhoneNum(context), // Số điện thoại (phone)
                  const SizedBox(height: 16),

                  _genderDropdown(), // Giới tính (gender)
                  const SizedBox(height: 30),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: AppButton(
                      content: _loading ? 'Processing...' : 'Complete Registration',
                      onPressed: _onFinishSignup,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS INPUT & STYLE ---

  InputDecoration _inputDecoration({required String hint, Widget? prefix, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColor.textpriCol),
      prefixIcon: prefix,
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xffFFFFFF),
      border: _border(Colors.transparent),
      enabledBorder: _border(Colors.transparent),
      focusedBorder: _border(AppColor.buttonprimaryCol),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );
  }
  
  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: color == AppColor.buttonprimaryCol ? 1.5 : 0),
    borderRadius: BorderRadius.circular(10),
  );

  Widget _inputWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            offset: const Offset(0, 1),
            blurRadius: 10,
            spreadRadius: -5,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _textFieldFullName(BuildContext context) {
    return _inputWrapper(
      child: TextFormField(
        controller: _nameController,
        cursorColor: AppColor.textpriCol,
        decoration: _inputDecoration(
          hint: 'Full Name',
          prefix: const Icon(Iconsax.user, color: AppColor.textpriCol),
        ),
        validator: _validateName,
      ),
    );
  }

  Widget _textFieldEmail(BuildContext context) {
    // Trường email chỉ hiển thị, không cho phép chỉnh sửa
    return _inputWrapper(
      child: TextFormField(
        initialValue: widget.email,
        readOnly: true, 
        cursorColor: AppColor.textpriCol,
        decoration: _inputDecoration(
          hint: 'Email',
          prefix: const Icon(Iconsax.sms, color: AppColor.textpriCol),
        ).copyWith(
          hintText: widget.email,
        ),
      ),
    );
  }

  Widget _textFieldPhoneNum(BuildContext context) {
    return _inputWrapper(
      child: TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        cursorColor: AppColor.textpriCol,
        decoration: _inputDecoration(
          hint: 'Phone Number',
          prefix: const Icon(Iconsax.call, color: AppColor.textpriCol),
        ),
        validator: _validatePhone,
      ),
    );
  }

  Widget _dateOfBirthField(BuildContext context) {
    return _inputWrapper(
      child: InkWell(
        onTap: _loading ? null : () => _selectDate(context),
        child: InputDecorator(
          decoration: _inputDecoration(
            hint: _selectedDate == null 
                  ? 'Date of Birth' 
                  : DateFormat('dd/MM/yyyy').format(_selectedDate!),
            prefix: const Icon(Iconsax.calendar, color: AppColor.textpriCol),
          ).copyWith(
            enabled: true,
          ),
           child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0), // Padding cho Text để khớp với TextFormField
            child: Text(
              _selectedDate == null
                  ? 'Date of Birth' // Nếu chưa chọn, hiển thị lại placeholder
                  : DateFormat('dd/MM/yyyy').format(_selectedDate!),
              style: TextStyle(
                // Đổi màu nếu là placeholder (chưa chọn)
                color: _selectedDate == null ? AppColor.textpriCol.withOpacity(0.6) : AppColor.textpriCol,
                fontSize: 16, // Đảm bảo kích thước chữ phù hợp
              ),
            ),
          ), // Không hiển thị textfield
        ),
      ),
    );
  }
  
  Widget _genderDropdown() {
    return _inputWrapper(
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        hint: const Text('Gender', style: TextStyle(color: AppColor.textpriCol)),
        decoration: _inputDecoration(
          hint: 'Gender',
          prefix: const Icon(Iconsax.user, color: AppColor.textpriCol),
          suffix: const Icon(Iconsax.arrow_down_1, color: AppColor.textpriCol, size: 20),
        ).copyWith(
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Iconsax.arrow_down_1, color: AppColor.textpriCol, size: 20),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
        isExpanded: true,
        items: _genders.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: AppColor.textpriCol)),
          );
        }).toList(),
        onChanged: _loading ? null : (String? newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
        validator: (value) => value == null ? 'Please select gender' : null,
        icon: const SizedBox.shrink(), // Tắt icon mặc định của DropdownButtonFormField
      ),
    );
  }

  Widget _editAvt() {
    // Logic cho edit Avatar (giữ nguyên nhưng loại bỏ lỗi 'spacing')
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.demoAvt),
            fit: BoxFit.cover,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 1),
              blurRadius: 10,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.buttomSecondCol,
                ),
                child: const Icon(Iconsax.edit, size: 16, color: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}