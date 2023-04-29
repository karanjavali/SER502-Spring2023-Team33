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
  output = '';
  ngOnInit() {
    this.codeInput = new FormControl('');
  }

  onRun() {
    let replaced_str = this.codeInput.value.replaceAll(";", " ;");
    let inputs = replaced_str.replace( /\n/g, " " ).split( " " );
    // for(let i=0;i<inputs.length;i++) {
    //   inpu
    // }
    let i=0;
    while(i<inputs.length) {
      inputs[i] = inputs[i].trim();
      console.log(inputs[i]);
      if (inputs[i].length == 0) {
        
        inputs.splice(i,1);
      }
      i++;
    }
    this.api.post("http://127.0.0.1:5000",{args:inputs}).subscribe((res:any) => {
      console.log(res);
      this.output = res.parse_tree + ', Z=' + res.output;
    })

  }
}
