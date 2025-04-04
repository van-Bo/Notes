## 明确
`C++` 的 `priority_queue` 内部维护的是一个堆（通常是二叉堆），其核心是通过比较器（或重载的 `<` 运算符）来维持堆的“有序”结构，而这个“有序”不是简单的升序或降序排列，而是一种局部性质——即 **堆顶元素总是被认为具有最高优先级**。而比较器返回的布尔值`true`并不是简单地表示“更小”或“更大”，而是告诉堆“第一个参数应该排在第二个参数后面”（也就是优先级低）

## 对于基本数据类型的小、大根堆实现
```C++
priority_queue<int> q;  //默认从大到小（大根堆）
priority_queue<int, vector<int>, less<int>> q;  //从大到小排序（大根堆）
priority_queue<int, vector<int>, greater<int>> q;   //从小到大排序（小根堆）
```

## 自定义优先级（`struct`）
1. 值小的优先级高（小根堆）
   - `u.x > v.x` 若返回 `true`，则表示 `v.x` 的优先级高于 `u.x`（小值优先即为小根堆）；反之，则 `u.x` 的优先级不小于 `v.x` 
```C++
#include <iostream>
#include <vector>
#include <queue>
using namespace std;
const int N = 1e5 + 10;

struct Node
{
    int x, y;
}nodes[N];

struct cmp1
{
    bool operator () (const Node &u, const Node &v)
    {
        return u.x > v.x;
    }
};

int main()
{
    nodes[0] = {-3, -9};
    nodes[1] = {1, 2};
    nodes[2] = {9, 4};
    nodes[3] = {8, 12};
    nodes[4] = {-19, 23};
    priority_queue<Node, vector<Node>, cmp1> q;

    for (int i = 0; i <= 4; i ++)
        q.push(nodes[i]);

    while (q.size())
    {
        auto t = q.top();
        q.pop();
        printf("x: %d ---- y: %d\n", t.x, t.y);
    }

    system("pause");
    return 0;
}
```
- 输出结果
![小根堆1.png](https://cdn.acwing.com/media/article/image/2024/04/27/261972_f514589f04-小.png) 

2. 值大的优先级高（大根堆）
      - `u.x < v.x` 若返回 `true`，则表示 `v.x` 的优先级高于 `u.x`（大值优先即为大根堆）；反之，则 `u.x` 的优先级不小于 `v.x` 
```C++
#include <iostream>
#include <vector>
#include <queue>
using namespace std;
const int N = 1e5 + 10;

struct Node
{
    int x, y;
}nodes[N];

struct cmp2
{
    bool operator () (const Node &u, const Node &v)
    {
        return u.x < v.x;
    }
};

int main()
{
    nodes[0] = {-3, -9};
    nodes[1] = {1, 2};
    nodes[2] = {9, 4};
    nodes[3] = {8, 12};
    nodes[4] = {-19, 23};
    priority_queue<Node, vector<Node>, cmp2> q;

    for (int i = 0; i <= 4; i ++)
        q.push(nodes[i]);

    while (q.size())
    {
        auto t = q.top();
        q.pop();
        printf("x: %d ---- y: %d\n", t.x, t.y);
    }

    system("pause");
    return 0;
}
```
- 输出结果
![大根堆1.png](https://cdn.acwing.com/media/article/image/2024/04/27/261972_76691dbd04-大.png) 

-------------------

## 重载 `<` 运算符
1. 值小的优先级高（小根堆）
   - `x > u.x` 若返回 `true`，则表示 `u.x` 的优先级高于 `x`（小值优先即为小根堆）；反之，则 `x` 的优先级不小于 `u.x` 
```C++
#include <iostream>
#include <vector>
#include <queue>
using namespace std;
const int N = 1e5 + 10;

struct Node
{
    int x, y;
    bool operator < (const Node &u) const
    {
        return x > u.x;
    }
}nodes[N];


int main()
{
    nodes[0] = {-3, -9};
    nodes[1] = {1, 2};
    nodes[2] = {9, 4};
    nodes[3] = {8, 12};
    nodes[4] = {-19, 23};
    priority_queue<Node> q;

    for (int i = 0; i <= 4; i ++)
        q.push(nodes[i]);

    while (q.size())
    {
        auto t = q.top();
        q.pop();
        printf("x: %d ---- y: %d\n", t.x, t.y);
    }

    system("pause");
    return 0;
}
```
- 输出结果
![小根堆2.png](https://cdn.acwing.com/media/article/image/2024/04/27/261972_3c457c0604-小小.png) 

2. 值大的优先级高（大根堆）
   - `x < u.x` 若返回 `true`，则表示 `u.x` 的优先级高于 `x`（大值优先即为大根堆）；反之，则 `x` 的优先级不小于 `u.x` 
```C++
#include <iostream>
#include <vector>
#include <queue>
using namespace std;
const int N = 1e5 + 10;

struct Node
{
    int x, y;
    bool operator < (const Node &u) const
    {
        return x < u.x;
    }
}nodes[N];


int main()
{
    nodes[0] = {-3, -9};
    nodes[1] = {1, 2};
    nodes[2] = {9, 4};
    nodes[3] = {8, 12};
    nodes[4] = {-19, 23};
    priority_queue<Node> q;

    for (int i = 0; i <= 4; i ++)
        q.push(nodes[i]);

    while (q.size())
    {
        auto t = q.top();
        q.pop();
        printf("x: %d ---- y: %d\n", t.x, t.y);
    }

    system("pause");
    return 0;
}
```
- 输出结果
![大大.png](https://cdn.acwing.com/media/article/image/2024/04/27/261972_5bc6a45804-大大.png)

## 自定义排序
1. 根据元素和进行降序排序
```C++
#include <iostream>
#include <cstring>
#include <algorithm>

using namespace std;
typedef pair<int, int> PII;
const int N = 1010;

struct Gift
{
    int p, s;
    bool operator < (const Gift& u) const
    {
        return p + s > u.p + u.s;
    }
}gift[N];

int main()
{
    gift[0] = {0, 2};
    gift[1] = {2, 3};
    gift[2] = {0, 1};
    
    sort(gift, gift + 3);
    for (int i = 0; i < 3; i ++)
    {
        printf("%d %d\n", gift[i].p, gift[i].s);
    }
    return 0;
}
```
2. 根据元素和进行升序排序
```C++
#include <iostream>
#include <cstring>
#include <algorithm>

using namespace std;
typedef pair<int, int> PII;
const int N = 1010;

struct Gift
{
    int p, s;
    bool operator < (const Gift& u) const
    {
        return p + s < u.p + u.s;
    }
}gift[N];

int main()
{
    gift[0] = {0, 2};
    gift[1] = {2, 3};
    gift[2] = {0, 1};
    
    sort(gift, gift + 3);
    for (int i = 0; i < 3; i ++)
    {
        printf("%d %d\n", gift[i].p, gift[i].s);
    }
    return 0;
}
```