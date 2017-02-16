
## JNSelectView

![Platform](http://img.shields.io/badge/platform-iOS-red.svg?style=flat
)
![Language](http://img.shields.io/badge/language-objective_c-brightgreen.svg?style=flat
)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

JNSelectView is simple SelectView component for iOS (Obj-C)<br/>

######multiple select
<img src="multipleSelect.gif" width="300">
######single select
<img src="singleSelect.gif" width="300">


## Usage
Just drag the folder 'SelectView' into your project.
###### single select
```objective-c
[JNSelectView presentSingleSelectViewWithList:aryDataList
                                        title:@"title"
                            completionHandler:^(NSInteger index)
{
    NSLog(@"Select Index: %d",index);
}];

```
###### multiple select
```objective-c
[JNSelectView presentMultipleSelectViewWithList:aryDataList
                                          title:@"title"
                              completionHandler:^(NSArray *aryList) {
    NSLog(@"Selected Indexes @[NSNumber] : %@",aryDataList);
}];

```
###### multiple select (max pick & minimum pick & Remain previous)
```objective-c
// self.m_arSelected first should be nil,
// point to aryList when completionHandler be called.

[JNSelectView presentMultipleSelectViewWithList:aryDataList
                                   selectedList:self.m_arySelected
                                          title:@"title"
                                        maxPick:4
                                    minimumPick:1
                              completionHandler:^(NSArray *aryList)
 {
     self.m_arySelected = aryList;
     NSLog(@"Selected Indexes @[NSNumber] : %@",aryDataList);
 }

```

## Feature
* Easy to use, using method with completionHandler!
* Available for all size (iPhone / iPad)
* Multiple select / Single select
* Configurate max pick and minimum pick(option)
* Remain Previous selected indexes.(option)

## License

JNSelectView is available under the MIT license. See the LICENSE file for more info.
