import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/food_item_provider.dart';
import '../models/food_item.dart';
import 'package:flutter/foundation.dart';
import '../screens/login_screen.dart';

class FoodDiaryScreen extends StatefulWidget {
  @override
  _FoodDiaryScreenState createState() => _FoodDiaryScreenState();
}

class _FoodDiaryScreenState extends State<FoodDiaryScreen> {
  late final TextEditingController _foodNameController;
  late final TextEditingController _foodAmountController;
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    _foodNameController =
        TextEditingController(text: kDebugMode ? 'Apple' : null);
    _foodAmountController =
        TextEditingController(text: kDebugMode ? '1 medium' : null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthentication();
    });
  }

  void _checkAuthentication() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void _saveFoodItem() async {
    try {
      final String name = _foodNameController.text.trim();
      final String amount = _foodAmountController.text.trim();
      final String dateTimeStr = _dateTimeController.text.trim();

      if (name.isEmpty || amount.isEmpty || dateTimeStr.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      final DateTime dateTime =
          DateFormat('yyyy-MM-dd HH:mm').parse(dateTimeStr, true).toLocal();

      final FoodItem foodItem = FoodItem(
        name: name,
        amount: amount,
        dateTime: dateTime,
      );

      await Provider.of<FoodItemProvider>(context, listen: false)
          .addFoodItem(foodItem);

      _foodNameController.clear();
      _foodAmountController.clear();
      _dateTimeController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food item saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _dateTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(
            DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return Center(child: CircularProgressIndicator());
    }

    final foodItems = Provider.of<FoodItemProvider>(context).foodItems;

    return Scaffold(
      appBar: AppBar(title: Text('Food Diary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Food Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _foodNameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Apple, Chicken Breast',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Enter Food Amount:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _foodAmountController,
                decoration: InputDecoration(
                  hintText: 'e.g., 1 medium, 100g',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16),
              Text(
                'Date and Time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _dateTimeController,
                decoration: InputDecoration(
                  hintText: 'YYYY-MM-DD HH:MM',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDateTime,
                  ),
                ),
                readOnly: true,
                onTap: _selectDateTime,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveFoodItem,
                child: Text('Save Food Item'),
              ),
              SizedBox(height: 24),
              Text(
                'Food Diary Entries:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              foodItems.isEmpty
                  ? Text('No food items saved.')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: foodItems.length,
                      itemBuilder: (context, index) {
                        final foodItem = foodItems[index];
                        return Card(
                          child: ListTile(
                            title: Text(foodItem.name),
                            subtitle: Text(
                                'Amount: ${foodItem.amount}\nDate/Time: ${DateFormat('yyyy-MM-dd HH:mm').format(foodItem.dateTime)}'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Confirm Deletion'),
                                    content: Text(
                                        'Are you sure you want to delete this food item?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Provider.of<FoodItemProvider>(context,
                                                  listen: false)
                                              .removeFoodItem(foodItem);
                                          Navigator.of(ctx).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Food item deleted')),
                                          );
                                        },
                                        child: Text('Delete',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _foodAmountController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }
}
