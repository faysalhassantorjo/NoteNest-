import 'package:flutter/material.dart';

class SocialFeedPage extends StatefulWidget {
  @override
  _SocialFeedPageState createState() => _SocialFeedPageState();
}

class _SocialFeedPageState extends State<SocialFeedPage> {
  int _currentIndex = 1;
  bool _showCreatePostForm = false;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  List<String> _tags = [];

  final List<Map<String, dynamic>> posts = [
    {
      'author': 'Faysal Torjo',
      'authorImage': 'https://randomuser.me/api/portraits/men/1.jpg',
      'postDate': '2 hours ago',
      'tags': ['Flutter', 'Design', 'UI'],
      'description':
          'A short description for this post about Flutter UI design principles.',
      'imageUrl': 'https://picsum.photos/500/300?random=1',
      'upvotes': 24,
      'contributions': 5,
      'isUpvoted': false,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pop(context);
    }
  }

  void _toggleUpvote(int index) {
    setState(() {
      posts[index]['isUpvoted'] = !posts[index]['isUpvoted'];
      if (posts[index]['isUpvoted']) {
        posts[index]['upvotes']++;
      } else {
        posts[index]['upvotes']--;
      }
    });
  }

  void _toggleCreatePostForm() {
    setState(() {
      _showCreatePostForm = !_showCreatePostForm;
    });
  }

  void _addTag() {
    if (_tagController.text.isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _submitPost() {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a description')),
      );
      return;
    }

    final newPost = {
      'author': 'Current User',
      'authorImage': 'https://randomuser.me/api/portraits/men/4.jpg',
      'postDate': 'Just now',
      'tags': List.from(_tags),
      'description': _descriptionController.text,
      'imageUrl': 'https://picsum.photos/500/300?random=${posts.length + 1}',
      'upvotes': 0,
      'contributions': 0,
      'isUpvoted': false,
    };

    setState(() {
      posts.insert(0, newPost);
      _descriptionController.clear();
      _tags.clear();
      _showCreatePostForm = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post created successfully!')),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NoteNest Feed'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return _buildPostCard(post, index);
            },
          ),
          if (_showCreatePostForm) _buildCreatePostForm(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCreatePostForm,
        child: Icon(_showCreatePostForm ? Icons.close : Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.live_help), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildCreatePostForm() {
    return Container(
      color: Colors.black54,
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create New Post',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    hintText: 'What do you want to share?',
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagController,
                        decoration: InputDecoration(
                          labelText: 'Add Tags',
                          border: OutlineInputBorder(),
                          hintText: 'Enter a tag and press +',
                        ),
                        onSubmitted: (_) => _addTag(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle),
                      color: Colors.blue,
                      onPressed: _addTag,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            deleteIcon: Icon(Icons.close, size: 16),
                            onDeleted: () => _removeTag(tag),
                          ))
                      .toList(),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.image),
                      label: Text('Add Image'),
                      onPressed: () {
                        // Implement image picker
                      },
                    ),
                    ElevatedButton(
                      onPressed: _submitPost,
                      child: Text('Post'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(post['authorImage']),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['author'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      post['postDate'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: post['tags'].map<Widget>((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: Colors.blue[50],
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[800],
                  ),
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.blue[100]!),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 12),
            Text(
              post['description'],
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post['imageUrl'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post['isUpvoted']
                            ? Icons.arrow_circle_up
                            : Icons.arrow_circle_up_outlined,
                        color: post['isUpvoted'] ? Colors.blue : null,
                        size: 28,
                      ),
                      onPressed: () => _toggleUpvote(index),
                    ),
                    Text(post['upvotes'].toString()),
                  ],
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.add, size: 18),
                  label: Text('Contribute'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                Text(
                  '${post['contributions']} contributions',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
