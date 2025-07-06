# 归并排序（链式存储）核心思想与实现总结

## 核心思想

归并排序在链表上的实现，是分治法 (Divide and Conquer) 的一个经典应用。其逻辑遵循三个步骤：

- 分解 (Divide)：通过递归，持续将当前链表从中间位置切分为两个长度相近的子链表，直到每个子链表只包含一个或零个节点。
- 解决 (Conquer)：当子链表只包含一个或零个节点时，我们可以认为它天然就是有序的。
- 合并 (Merge)：将两个已经排好序的子链表，合并成一个更长的、有序的链表。

## 关键实现技巧

### 如何切分链表：快慢指针法

为了在不知道链表长度的情况下，高效地找到链表的中点并进行切分，我们采用快慢指针 (Fast/Slow Pointer) 技巧。

**原理**：创建两个指针 `slow` 和 `fast`，初始时都指向链表头。`slow` 指针每次移动一步，`fast` 指针每次移动两步。

**效果**：当 fast 指针到达或越过链表末尾时，slow 指针正好位于链表的中间位置。

**切分操作**：在遍历时，额外使用一个 `prev` 指针记录 `slow` 的前一个节点。找到中点后，通过 `prev->next = nullptr;` 即可将链表一分为二。

这个方法可避免了需要预先计算长度或传递长度参数的麻烦。

### 如何合并链表：指针重链接 (O(1) 额外数据空间)

这是链表归并排序相对于数组版本最大的优势所在，它不需要像数组那样开辟一个包含 n 个元素的额外存储空间。

**原理**：合并操作并非创建新节点，而是将两个有序子链表的已有节点的 `next` 指针进行重新链接 (Re-linking)。

**实现**：

- 哑节点 (Dummy Node)：创建一个临时的、固定的 `dummy` 节点作为新链表的“挂钩”或“火车头”，以简化代码逻辑。

- 尾指针 (Tail Pointer)：创建一个 `tail` 指针，作为移动的“工人”，初始指向 `dummy` 节点。`tail` 的任务是依次比较两个子链表的头节点，将较小的那个节点链接到自己的 next，然后 tail 自身移动到新链接的节点上，时刻保持在合并后链表的尾部。

整个合并过程没有创建新的数据节点，只是将已有节点的 `next` 指针重新指向，实现了空间上的巨大优化。

**性能分析**
时间复杂度：无论是最好、最坏还是平均情况，时间复杂度均为 $O(n \log n)$

- 递归树的深度为 $O(\log n)$

- 在每一层递归中，所有子链表的合并操作加起来，总共需要遍历该层的所有 n 个节点，因此每层的操作是 O(n)。

空间复杂度：$O(\log n)$

- 数据空间：$O(1)$，如上所述，合并操作仅重排指针，不分配额外的数据节点。

- 递归栈空间：$O(\log n)$，这是空间开销的主要来源，由递归调用的深度决定。

稳定性：稳定 (Stable)。

- 在合并两个子链表时，如果遇到值相等的节点，我们总是优先选择来自第一个子链表的节点。这样可以保证原始序列中相等元素的相对顺序不被改变。

## 基于 C++ 的代码实现

```c++
/**
 * Definition for singly-linked list.
 */
struct ListNode {
    int val;
    ListNode *next;
    ListNode(int x) : val(x), next(nullptr) {}
};

class Solution {
public:
    // 主函数，归并排序的入口
    ListNode* sortList(ListNode* head) {
        // 递归终止条件：链表为空或只有一个节点，已天然有序
        if (!head || !head->next) {
            return head;
        }

        // 1. 使用快慢指针找到中点，并切分链表
        ListNode* slow = head;
        ListNode* fast = head;
        ListNode* prev = nullptr;

        while (fast != nullptr && fast->next != nullptr) {
            prev = slow;
            slow = slow->next;
            fast = fast->next->next;
        }
        
        // 从中点前一个节点处断开链表，形成两个子链表
        if (prev != nullptr) {
            prev->next = nullptr;
        }

        // 2. 递归地对左右两个子链表进行排序
        ListNode* left_sorted = sortList(head);  // 左半部分
        ListNode* right_sorted = sortList(slow); // 右半部分

        // 3. 合并两个已排序的子链表
        return merge(left_sorted, right_sorted);
    }

private:
    // 辅助函数：合并两个有序链表 l1 和 l2
    ListNode* merge(ListNode* l1, ListNode* l2) {
        // 创建一个哑节点(dummy node)作为新链表的头，简化代码
        ListNode dummy(0);
        ListNode* tail = &dummy; // tail 指针用于构建新链表

        // 当两个链表都不为空时，比较并链接较小的节点
        while (l1 != nullptr && l2 != nullptr) {
            if (l1->val <= l2->val) {
                tail->next = l1;
                l1 = l1->next;
            } else {
                tail->next = l2;
                l2 = l2->next;
            }
            tail = tail->next; // 移动 tail 指针
        }

        // 将剩余的非空链表直接链接到末尾
        if (l1 != nullptr) {
            tail->next = l1;
        } else {
            tail->next = l2;
        }

        // 返回哑节点的下一个节点，即合并后链表的真正头节点
        return dummy.next;
    }
};
```
