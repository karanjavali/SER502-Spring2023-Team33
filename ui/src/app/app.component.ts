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
    let inputs = this.codeInput.value.replace( /\n /g, " " ).split( " " );
    // for(let i=0;i<inputs.length;i++) {
    //   inpu
    // }
    this.api.post("http://127.0.0.1:5000",inputs).subscribe((res:any) => {
      console.log(res);
      this.output = res.parse_tree + ', Z=' + res.output;
    })

  }
}
