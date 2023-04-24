import { Component } from '@angular/core';
import { FormControl } from '@angular/forms';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  codeInput:any;
  output = '';
  ngOnInit() {
    this.codeInput = new FormControl('');
  }

  onRun() {
    console.log(this.codeInput.value);
    this.output = this.codeInput.value;
    
  }
}
