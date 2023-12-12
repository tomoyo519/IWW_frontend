import 'package:flutter/material.dart';

class FontTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 테마 데이터에 접근하기 위한 테마 객체
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('글씨체 테스트 페이지'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Title Large', style: textTheme.titleLarge),
              SizedBox(height: 10),
              Text('Title Medium', style: textTheme.titleMedium),
              SizedBox(height: 10),
              Text('Title Small', style: textTheme.titleSmall),
              SizedBox(height: 20),
              Text('Headline Large', style: textTheme.headlineLarge),
              SizedBox(height: 10),
              Text('Headline Medium', style: textTheme.headlineMedium),
              SizedBox(height: 10),
              Text('Headline Small', style: textTheme.headlineSmall),
              SizedBox(height: 20),
              Text('Body Large', style: textTheme.bodyLarge),
              SizedBox(height: 10),
              Text('Body Medium', style: textTheme.bodyMedium),
              SizedBox(height: 10),
              Text('Body Small', style: textTheme.bodySmall),
              SizedBox(height: 20),
              // 추가적인 텍스트 스타일을 테스트하기 위해 더 많은 텍스트 위젯을 추가할 수 있습니다.
            ],
          ),
        ),
      ),
    );
  }
}