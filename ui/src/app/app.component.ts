import { Component } from '@angular/core';
import { FormControl } from '@angular/forms';
import { ApiService } from './services/api.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  
  constructor(private api:ApiService) {

  }

  codeInput:any;
  output:any = [];
  ngOnInit() {
    this.codeInput = new FormControl('');
  }
  status = 0;
  onRun() {
    let replace_strings:any = {
      // "=": " = ", // implement later
      ":=": " := ",
      "+": " + ",
      "-": " - ",
      "/": " / ",
      "*": " * ",
      ";": " ; ",
      ".": " . ",
      "\n": " ",
      "\t": " ",
      ">=": " >= ",
      "<=": " <= ",
      "\"": " \" "
    }
    let replaced_str = this.codeInput.value;
    for (let key of Object.keys(replace_strings)) {
      replaced_str = replaced_str.replaceAll(key, replace_strings[key]); 
    }
    replaced_str.replaceAll("")
    let inputs = replaced_str.split( " " );
    let i=0;
    while(i<inputs.length) {
      inputs[i] = inputs[i].trim();
      console.log(inputs[i]);
      if (inputs[i].length == 0) {
        
        inputs.splice(i,1);
      }
      else {
        i++;
      }
    }
    this.api.post("http://127.0.0.1:5000",{args:inputs}).subscribe((res:any) => {
      console.log(res);
      let outputs = res.res;
      this.status = res.status;
      this.output = outputs.split("\r\n");
      if(typeof(this.output) == "string") {
        this.output = [];
      }
      else {
        this.output.pop();
      }
      
    })

  }
}
