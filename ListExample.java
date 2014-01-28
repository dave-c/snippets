// taken from: http://stackoverflow.com/questions/11331591/arraylist-insertion-and-retrieval-order
// to compile: javac <filename>.java
// to run: java <filename>

import java.util.*;

public class ListExample
{
  public static void main(String[] args)
  {
    List<String> myList = new ArrayList<String>();

    myList.add("one");
    myList.add("two");
    myList.add("three");
    myList.add("four");
    myList.add("five");

    System.out.println("Inserted in 'order': ");
    printList(myList);

    myList.clear();

    myList.add("four");
    myList.add("five");
    myList.add("one");
    myList.add("two");
    myList.add("three");

    System.out.println("Inserted out of 'order': ");
    printList(myList);
  }


  private static void printList(List<String> myList)
  {
    for (String string : myList) {
      System.out.println(string);
    }
  }
}
