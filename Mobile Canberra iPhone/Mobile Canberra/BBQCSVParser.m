// ************************************************************************************
//
//  BBQCSVParser.m
//  BBQKing
//
// ************************************************************************************

// Header file
#import "BBQCSVParser.h"

// ************************************************************************************

@implementation BBQCSVParser

// ************************************************************************************


#pragma mark -
#pragma mark CSV parsing methods


// --------------------------------------------
// * Create an array from a CSV NSData object *
// --------------------------------------------

- (NSArray *)arrayFromCSVData:(NSData *)_csvData headerRow:(Boolean)_headerRow {
    
    // Convert the NSData into an NSString
    NSString *csvString = [[NSString alloc] initWithData:_csvData encoding:NSUTF8StringEncoding];
        
    // Split each record (line) in the csvDataString into an individual array element (split on the newline character \n)
    NSArray *csvArray = [csvString componentsSeparatedByString:@"\n"];
        
    // Create an array to hold the parsed CSV data
    NSMutableArray *parsedCSVArray = [[NSMutableArray alloc] init];
        
    // If there is a heading row then start the loop counter at 1 (to skip the heading row)    
    for (int i = (_headerRow ? 1 : 0); i < [csvArray count]; i++) {
        
        // Get a reference to this record (line) as a string, and remove any extranous new lines or alike
        NSString *csvRecordString = [[csvArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                
        // Split the line by the comma delimeter
        NSArray *csvRecordArray = [csvRecordString componentsSeparatedByString:@","];
                
        // Check that there are actually fields (i.e. this is not a blank line)
        if ( ([csvRecordArray count] > 0) && ([[csvRecordArray objectAtIndex:0] length] > 0) ) {
            
            // Add the record array to the parsed csv array
            [parsedCSVArray addObject:csvRecordArray];
            
        }
        
    }
        
    // Return the parsed array
    return parsedCSVArray;
    
}

@end