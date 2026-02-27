import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';

import '../../../data/repositories/register_repository_impl.dart';
import '../../../data/datasources/register_remote_datasource.dart';
import '../../../core/api/api_client.dart';

class RegisterOverviewPage extends StatefulWidget {
  const RegisterOverviewPage({super.key});

  @override
  State<RegisterOverviewPage> createState() => _RegisterOverviewPageState();
}

class _RegisterOverviewPageState extends State<RegisterOverviewPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cityController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedAge;

  final List<String> _genders = ['Mand', 'Kvinde', 'Andet'];

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        _selectedAge = selectedDate;
      });
    }
  }

  void _register(BuildContext context) {
    if (_selectedAge == null || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vælg venligst fødselsdag og køn')),
      );
      return;
    }

    context.read<RegisterBloc>().add(
          RegisterButtonPressed(
            email: _emailController.text,
            name: _nameController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            city: _cityController.text,
            gender: _selectedGender!,
            age: _selectedAge!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocProvider(
        create: (context) => RegisterBloc(
          repository: RegisterRepositoryImpl(
            remoteDataSource: RegisterRemoteDataSourceImpl(
              apiClient: ApiClient(),
            ),
          ),
        ),
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            if (state is RegisterInitial) {
              return _buildRegisterForm(context);
            } else if (state is RegisterLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RegisterSuccess) {
              return const Center(child: Text('Registration successful!'));
            } else if (state is RegisterFailure) {
              return Center(child: Text('Registration failed: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(labelText: 'City'),
          ),
          const SizedBox(height: 16),
          DropdownButton<String>(
            isExpanded: true,
            hint: const Text('Select Gender'),
            value: _selectedGender,
            items: _genders.map((gender) {
              return DropdownMenuItem(value: gender, child: Text(gender));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(
              _selectedAge == null
                  ? 'Select Date of Birth'
                  : 'Date: ${_selectedAge!.toLocal()}'.split(' ')[0],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _register(context),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
