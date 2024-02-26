class TransactionTile extends StatelessWidget {
  // ... existing properties ...

  @override
  Widget build(BuildContext context) {
    // Extract the first letter of the name, or use a fallback character if the name is empty
    String displayNameInitial = name.isNotEmpty ? name[0] : '#';

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            // ... other ListTile properties ...
            leading: Container(
              // ... other Container properties ...
              child: Center(
                child: Text(
                  displayNameInitial,
                  style: const TextStyle(
                    // ... TextStyle properties ...
                  ),
                ),
              ),
            ),
            // ... other ListTile children ...
          ),
          const Divider(
            // ... Divider properties ...
          )
        ],
      ),
    );
  }
}
