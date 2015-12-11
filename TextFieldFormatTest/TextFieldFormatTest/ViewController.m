//
//  ViewController.m
//  TextFieldFormatTest
//
//  Created by Nikolay Berlioz on 06.12.15.
//  Copyright © 2015 Nikolay Berlioz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"textField text = %@", textField.text);
//    NSLog(@"shouldChangeCharactersInRange %@", NSStringFromRange(range));
//    NSLog(@"replacementString %@", string);
    
    NSCharacterSet *validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1)
    {
        return NO;
    }
 
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSLog(@"new string %@", newString);
    
    NSArray *validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    
    newString = [validComponents componentsJoinedByString:@""];
    
    static const int localNumberMaxLenght = 7;
    static const int areaCodeMaxLenght = 3;
    static const int countryCodeMaxLenght = 3;
    
    if (newString.length > localNumberMaxLenght + areaCodeMaxLenght + countryCodeMaxLenght)
    {
        return NO;
    }
    
    
    NSMutableString *resultString = [NSMutableString string];
    
    NSInteger localNumberLenght = MIN([newString length], localNumberMaxLenght);
   
    if (localNumberLenght > 0)
    {
        NSString *number = [newString substringFromIndex:(int)[newString length] - localNumberLenght];
        
        [resultString appendString:number];
        
        if (resultString.length > 3)
        {
            [resultString insertString:@"-" atIndex:3];
        }
    }
    
    if (newString.length > localNumberMaxLenght)
    {
        NSInteger areaCodeLenght = MIN((int)newString.length - localNumberMaxLenght, countryCodeMaxLenght);
        
        NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLenght - areaCodeLenght, areaCodeLenght);
        
        NSString *area = [newString substringWithRange:areaRange];
        
        area = [NSString stringWithFormat:@"(%@) ", area];
        
        [resultString insertString:area atIndex:0];

    }
    
    if (newString.length > localNumberMaxLenght + areaCodeMaxLenght)
    {
        NSInteger countryCodeLenght = MIN((int)newString.length - localNumberMaxLenght - areaCodeMaxLenght, areaCodeMaxLenght);
        
        NSRange countryCodeRange = NSMakeRange(0, countryCodeLenght);
        
        NSString *countryCode = [newString substringWithRange:countryCodeRange];
        
        countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
        
        [resultString insertString:countryCode atIndex:0];
        
    }
    
    textField.text = resultString;
    
    return NO;
    
    
    
    
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" ,"];
   /*
    NSCharacterSet *set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    NSArray *words = [resultString componentsSeparatedByCharactersInSet:set];
    
    NSLog(@"%@", words);
    return resultString.length <= 10;

    */
    
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField;


@end
